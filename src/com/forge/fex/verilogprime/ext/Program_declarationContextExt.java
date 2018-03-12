package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Program_declarationContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Program_declarationContextExt extends AbstractBaseExt {

	public Program_declarationContextExt(Program_declarationContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Program_declarationContext getContext() {
		return (Program_declarationContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).program_declaration());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Program_declarationContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Program_declarationContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}