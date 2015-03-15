classdef LinkedListNode < matlab.mixin.Copyable
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Constant)
        
    end
    
    properties (GetAccess = public, SetAccess = protected)
        % ----------- %
        % Attributes
        % ----------- %
        time
        updatedPosition = false;
        updatedHeadTime = false;
        
        % ----------- %
        % Objects
        % ----------- %
        next = [];
        prev = [];
        
    end
    
    properties (GetAccess = protected, SetAccess = protected)
        position
        headTime        % Time of head node
    end
    
    properties (Dependent)
        
    end
    
    methods
        %% Constructor
        
        function thisNode = LinkedListNode(time)
            thisNode.time = time;
        end
            
        
        %% Getter functions
        

        
        %% Regular methods
        
        % ----------------------------------------------------------------
        % ---------- Accessor methods ------------------------------------
        % ----------------------------------------------------------------
        
        
        % ----------------------------------------------------------------
        % ---------- Mutator methods -------------------------------------        
        % ----------------------------------------------------------------
        
        
         %{
        * Sets all backward measures out-of-date.
        
            Input
                Observation
            Output
                
        %}
        function setAllBackwardMeasuresAsOutdated(thisNode)
            thisNode.updatedPosition = false;
            thisNode.updatedHeadTime = false;
            
            if ~thisNode.isLast()
                % Outdated state propagates forward
                thisNode.next.setAllBackwardMeasuresAsOutdated();
            end
        end
        
        
        %{
        * Sets the next node object
        
            Input
                node
            Output
                
        %}
        function setNext(thisNode, node)
            
            assert( thisNode.isSameClass(node), 'Objects must be of the same class.' )
            assert(thisNode.time <= node.time, 'The node object to be added must have an equal or greater time attribute.')
            
            thisNode.next = node;
        end
        
        %{
        * Sets the previous node object
        
            Input
                node
            Output
                
        %}
        function setPrev(thisNode, node)
            
            assert( thisNode.isSameClass(node), 'Objects must be of the same class.' )
            assert(thisNode.time >= node.time, 'The node object to be added must have an equal or less time attribute.')
            
            thisNode.prev = node;
            
            thisNode.setAllBackwardMeasuresAsOutdated();
        end
        
        %{
        * Removes "next" attribute of thisNode and turns it into an empty
        value
        
            Input
                node
            Output
                
        %}
        function removeNext(thisNode)
            thisNode.next = [];
        end
        
        
        
        %{
        * Removes "prev" attribute of thisNode and turns it into an empty
        value
        
            Input
                node
            Output
                
        %}
        function removePrev(thisNode)
            thisNode.prev = [];
            thisNode.setAllBackwardMeasuresAsOutdated();
        end
        
        %{
        * Adds a node object immediately after thisNode
        
            Input
                node
            Output
                
        %}
        function insertAfter(thisNode, node)
            cond_class = strcmp(class(node),class(thisNode));
            cond_interior = thisNode.isInterior();
            cond_single = node.isSingle();
            cond_last = thisNode.isLast();
            cond_first = thisNode.isFirst();
            
            % ----------
            if ~cond_class
                error('The object to insert must be a node')
            end
            
            if cond_interior
                assert(cond_single, ...
                    'Since the object receving the insertion is interior, the INSERTED object must be SINGLE')
            end
            
            % ----------
            if cond_last
                assert(node.isFirst(), ...
                    'Since the object receiving the insertion is tail, the INSERTED object must be head');
            end
            
            if cond_first && ~thisNode.isSingle();
                assert(cond_single, ...
                    'Since the object receiving the insertion is head and NOT SINGLE, then the INSERTED object must be SINGLE');
            end
            
            oldNext = thisNode.next;
            
            thisNode.setNext(node);
            node.setPrev(thisNode);
            
            if ~isempty(oldNext)
                assert(cond_single, ...
                    'Since the object receving the insertion has a next, the INSERTED object must be SINGLE');
                node.setNext(oldNext);
                oldNext.setPrev(node);
            end
            
        end
        
        %{
        * Adds a node object immediately before thisNode
        
            Input
                node
            Output
                
        %}
        function insertBefore(thisNode, node)
            cond_class = strcmp(class(node),class(thisNode));
            cond_interior = thisNode.isInterior();
            cond_single = node.isSingle();
            cond_first = thisNode.isFirst();
            cond_last = thisNode.isLast();
            
            % ----------
            if ~cond_class
                error('The object to insert must be a node')
            end
                        
            if cond_interior
                assert(cond_single, ...
                    'Since the object receving the insertion is interior, the INSERTED object must be SINGLE')
            end
            
            % ----------
            
            if cond_first
                assert(node.isLast() , ...
                    'Since the object receiving the insertion is Head, the INSERTED object must be Tail')
            end
            
            if cond_last && ~thisNode.isSingle();
                assert( cond_single, ...
                    'Since the object receiving the insertion is Tail, the INSERTED object must be SINGLE');
            end
            % ---------
            
            
            oldPrev = thisNode.prev;
            
            thisNode.setPrev(node);
            node.setNext(thisNode);
            
            if ~isempty(oldPrev)
                node.setPrev(oldPrev);
                oldPrev.setNext(node);
            end
            
        end
        
        %{
        * Extracts copy of object from list without modifying the original
        list. It also removes prev and next associations of extacted copy
        
            Input
                node
            Output
                ext : [class LinkedListNode] Isolated copy of extracted
                object
                
        %}
        function ext = extractCopy(thisNode)
            ext = copy(thisNode);
            if not(thisNode.isSingle())
                ext.removeNext();
                ext.removePrev();
            end
        end
        
        %{
        * Remove a node object from the linked list it belongs (if any)
        
            Input
                
            Output
                adj: [class LinkedListNode] node object adjacent to removed
                object. If removed object is not first and not single, the previous object
                is returned. If it is first and not single, the next object
                is returned. If it is single, an empty array is returned.
        %}
        function adj = remove(thisNode)
            % Saves associations of this thisNode
            adj_next = thisNode.next;
            adj_prev = thisNode.prev;
            
            % Removes old associations of thisNode
            thisNode.removeNext();
            thisNode.removePrev();
            
            % Removes old associations of adj_next and adj_prev
            if ~isempty(adj_next)
                adj_next.removePrev();
            end
            if ~isempty(adj_prev)
                adj_prev.removeNext();
            end
            
            if ~isempty(adj_next)
                if ~isempty(adj_prev)
                    % Is interior
                    adj_next.insertBefore(adj_prev);
                    adj = adj_prev;
                else
                    % Is first
                    adj_next.prev = [];
                    adj = adj_next;
                end
            else % If adj_next is empty
                if ~isempty(adj_prev)
                    % Is last
                    adj_prev.next = [];
                    adj = adj_prev;
                else
                    % Is single
                    adj = [];
                end
            end
        end
        
        % ----------------------------------------------------------------
        % ---------- Informative methods ---------------------------------
        % ----------------------------------------------------------------
        
        %{
        * Finds out whether thisNode is the first or not within the
        linked list
        
            Input
            
            Output
                answer: [class boolean] True if it is the first, false
                otherwise.
        %}
        function answer = isFirst(thisNode)
            if ~isempty(thisNode.prev)
                answer = false;
            else
                answer = true;
            end
        end
        
        %{
        * Finds out whether thisNode is the last or not within the
        linked list
        
            Input
            
            Output
                answer: [class boolean] True if it is the last, false
                otherwise.
        %}
        function answer = isLast(thisNode)
            if ~isempty(thisNode.next)
                answer = false;
            else
                answer = true;
            end
        end
        
        %{
        * Finds out whether thisNode is an interior node or not within the
        linked list
        
            Input
            
            Output
                answer: [class boolean] True if it is an interior node,
                false otherwise.
        %}
        function answer = isInterior(thisNode)
            if ~thisNode.isFirst() && ~thisNode.isLast()
                answer = true;
            else
                answer = false;
            end
        end
        
        %{
        * Finds out whether thisNode is the only node or not within the
        linked list
        
            Input
            
            Output
                answer: [class boolean] True if it is the only node,
                false otherwise.
        %}
        function answer = isSingle(thisNode)
            if thisNode.isFirst() && thisNode.isLast()
                answer = true;
            else
                answer = false;
            end
        end
        
        %{
        * 
        
            Input
            
            Output
                
        %}
        function head = returnHead(thisNode)
            if thisNode.isFirst()
                head = thisNode;
            else
                head = returnHead(thisNode.prev);
            end
        end
        
        %{
        * 
        
            Input
            
            Output
                
        %}
        function tail = returnTail(thisNode)
            if thisNode.isLast()
                tail = thisNode;
            else
                tail = returnTail(thisNode.next);
            end
        end
        
        
        %{
        * 
        
            Input
            
            Output
                
        %}
        function pos = getPosition(thisNode)
            pos = thisNode.position;
            if thisNode.updatedPosition == false
                if thisNode.isFirst()
                    pos = 1;
                else
                    pos = thisNode.prev.getPosition() + 1;
                end
                
                if isempty(pos)
                    error('The position attritube is empty even though the method has finished')
                end
                
                thisNode.position = pos;
                thisNode.updatedPosition = true;
            end
        end
        
        
        %{
        * 
        
            Input
            
            Output
                
        %}
        function ht = getHeadTime(thisNode)
            ht = thisNode.headTime;
            if thisNode.updatedHeadTime == false
                if thisNode.isFirst()
                    ht = thisNode.time;
                else
                    ht = thisNode.prev.getHeadTime();
                end
                
                thisNode.headTime = ht;
                thisNode.updatedHeadTime = true;
            end
        end
        
        
        %{
        * 
        
            Input
            
            Output
                
        %}
        function cont = getLength(thisNode)
            cont = 0;
            current = thisNode.returnHead();
            while not(current.isLast())
                current = current.next;
                cont = cont + 1;
            end
            
            cont = cont+1;
        end
        
        function returnNodeJustBeforeTime(thisNode, time)
            minTime = thisNode.getHeadTime();
            tail = thisNode.returnTail();
            maxTime = tail.time;
            
            assert(minTime <= time && time <= maxTime, ...
                'This linkedList does not contain this time')
            
            
        end
        
        %{
        * 
        
            Input
            
            Output
                timeSeries: [class Array of double] Contains series of time
                corresponding to each node. Column vector
                
        %}
        function timeSeries = returnTimeSeries(thisNode)
            nFlows = thisNode.getLength();
            timeSeries = zeros(nFlows, 1);
            current = thisNode.returnHead();
            
            cont = 1;
            
            while not(current.isLast())
                timeSeries(cont) = current.time;
                current = current.next;
                cont = cont + 1;
            end
            
            timeSeries(cont) = current.time;
        end
        
        
        function answer = hasEqualTimeValues(thisNode)
            timeSeries = thisNode.returnTimeSeries();
            if range(timeSeries) == 0
                answer = true;
            else
                answer = false;
            end
        end
        
        function answer = isSameClass(thisNode, object)
            answer = isa(object, class(thisNode));
        end
        
    end
    
end

%% Auxiliar functions

    %{
    * Description of the auxiliar function
    
        Input

        Output

    %}


