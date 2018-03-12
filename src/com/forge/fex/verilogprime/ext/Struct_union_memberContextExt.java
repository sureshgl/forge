package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Struct_union_memberContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Struct_union_memberContextExt extends AbstractBaseExt {

	public Struct_union_memberContextExt(Struct_union_memberContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Struct_union_memberContext getContext() {
		return (Struct_union_memberContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).struct_union_member());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Struct_union_memberContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Struct_union_memberContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}