IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_NamesAtRankWithAncestor')
	BEGIN
		DROP  Procedure  sprSelect_NamesAtRankWithAncestor
	END

GO

CREATE Procedure sprSelect_NamesAtRankWithAncestor
	@providerNamePk int,
	@threshold int
AS
	--updates any current matched names so that they are the same rank as the prov name we are matching
	-- this is done by getting all child names of the "ancestor" of the provider name, then
	-- recursing down the tree from each name until we get to a name with the appropriate rank
	--This procedure doesnt really fail, as it only adds extra names to the matched list
	
	set nocount on
	
	declare @rank int, @ancestorRank int, @pnRank int
	declare @ancestor uniqueidentifier
	declare @names table(rowId int identity, nameGuid uniqueidentifier, rankFk int)
    declare @currentName uniqueidentifier, @rankName nvarchar(50), @selId uniqueidentifier
	
	select @pnRank = pnnameRankFk, @rank = pnnamerankfk from tblprovidername where pnpk = @providerNamePk
	select @ancestorRank = ancestorrankfk from tblrank where rankpk = @rank
	
	--print(@ancestorRank)
	
	if (@ancestorRank is not null)
	begin	
		--get ancestor
		select top 1 @currentName = MatchResultRecordId from tmpmatchresults
		
		if (@currentName is null) --previous step failed, ie no names, so get consensus parent name record
		begin
			declare @name1Id nvarchar(300), @provPk int

			select @name1Id = PNNameId, @provPk = ProviderPk from vwProviderName where PNPk = @providerNamePk
	
			select @currentName = PNNameFk
			from vwProviderConceptRelationship pcr
			inner join vwProviderName pn on pn.PNNameId = pcr.PCName2Id and pn.ProviderPk = pcr.ProviderPk
			where PCName1Id = @name1Id and PCRRelationshipFk = 6 and pcr.ProviderPk = @provPk --parent type
		end
			    	   			    	   
		while (@currentName is not null and @rank is not null)
		begin
			if (@rank = @ancestorRank)
			begin
				set @selId = @currentName
				set @currentName = null --to exit while loop
			end
			else
			begin
				select @currentName = NameParentFk 
				from tblName 
				where NameGuid = @currentName
	            
				select @rank = r.RankPk
				from tblName n
				inner join tblRank r on r.RankPk = n.NameRankFk
				where NameGuid = @currentName
				
				print(@rank)
			end        
		end
	    
	    print(@selId)
	    
	    if (@selId is not null)
	    begin
			--@selId is ancestor name
			--get all children
		    				    
			/*insert @names(nameGuid)
			select n.nameguid
			from tblname n 
			inner join tblname pn on pn.nameguid = n.nameparentfk
			inner join tblname n1 on n1.nameguid = pn.nameparentfk
			inner join tmpmatchresults on matchresultrecordid = n1.nameguid
			where n.namerankfk = @pnrank
			union
			select n.nameguid
			from tblname n 
			inner join tblname pn on pn.nameguid = n.nameparentfk
			inner join tblname n1 on n1.nameguid = pn.nameparentfk
			inner join tblname n2 on n2.nameguid = n1.nameparentfk
			inner join tmpmatchresults on matchresultrecordid = n2.nameguid
			where n.namerankfk = @pnrank
			union
			select n.nameguid
			from tblname n 
			inner join tblname pn on pn.nameguid = n.nameparentfk
			inner join tblname n1 on n1.nameguid = pn.nameparentfk
			inner join tblname n2 on n2.nameguid = n1.nameparentfk
			inner join tblname n3 on n3.nameguid = n2.nameparentfk
			inner join tmpmatchresults on matchresultrecordid = n3.nameguid
			where n.namerankfk = @pnrank
			union
			select n.nameguid
			from tblname n 
			inner join tblname pn on pn.nameguid = n.nameparentfk
			inner join tblname n1 on n1.nameguid = pn.nameparentfk
			inner join tblname n2 on n2.nameguid = n1.nameparentfk
			inner join tblname n3 on n3.nameguid = n2.nameparentfk
			inner join tblname n4 on n4.nameguid = n3.nameparentfk
			inner join tmpmatchresults on matchresultrecordid = n4.nameguid
			where n.namerankfk = @pnrank
			union
			select n.nameguid
			from tblname n 
			inner join tblname pn on pn.nameguid = n.nameparentfk
			inner join tblname n1 on n1.nameguid = pn.nameparentfk
			inner join tblname n2 on n2.nameguid = n1.nameparentfk
			inner join tblname n3 on n3.nameguid = n2.nameparentfk
			inner join tblname n4 on n4.nameguid = n3.nameparentfk
			inner join tblname n5 on n5.nameguid = n4.nameparentfk
			inner join tmpmatchresults on matchresultrecordid = n5.nameguid
			where n.namerankfk = @pnrank
		    */
		    
		    	
			insert @names
			select nameguid, namerankfk
			from tblname n
			where nameparentfk = @selId
			
			--iterate through all names until they are all of the correct rank
			while (exists(select * from @names where rankFk <> @pnrank))
			begin
				declare @pos int, @last int, @n uniqueidentifier, @r int
				select @pos = min(rowId) from @names
				select @last = max(rowId) from @names
				
				--print (@pos)
				--print(@last)
				
				while (@pos <= @last)
				begin
					if (exists(select * from @names where rowid = @pos and rankfk <> @pnrank))
					begin
						select @n = nameGuid, @r = rankFk from @names where rowId = @pos
						
						if (@r <> @pnrank)
						begin
							insert @names
							select nameguid, namerankfk
							from tblname where nameparentfk = @n
							
							delete @names where nameguid = @n
							delete tmpmatchresults where matchresultrecordid = @n
						end
					end
					
					set @pos = @pos + 1
					select @last = max(rowId) from @names
				end
							
			end
			
			if ((select count(*) from @names) > 0)
			begin
				insert tmpMatchResults
				select n.NameGuid, 100
				from @names n
				where not exists(select * from tmpmatchresults where matchresultrecordid = n.nameguid)
			end
		end
	end

GO


GRANT EXEC ON sprSelect_NamesAtRankWithAncestor TO PUBLIC

GO


