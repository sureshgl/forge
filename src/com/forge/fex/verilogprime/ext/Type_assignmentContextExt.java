package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Type_assignmentContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Type_assignmentContextExt extends AbstractBaseExt {

	public Type_assignmentContextExt(Type_assignmentContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Type_assignmentContext getContext() {
		return (Type_assignmentContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).type_assignment());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Type_assignmentContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Type_assignmentContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}